#!/usr/bin/env bash
#
# apps.sh — modo rofi custom tipo "drun" con numeración 1-5 en las
# apps más usadas (para usar con Ctrl+1..5).
#
# Uso en config.rasi / línea de comandos:
#   rofi -show apps -modi "apps:$HOME/.config/rofi/scripts/apps.sh"
#
# Guarda el conteo de uso en ~/.cache/rofi-apps/usage.tsv
#
set -uo pipefail

CACHE_DIR="$HOME/.cache/rofi-apps"
USAGE_FILE="$CACHE_DIR/usage.tsv"
mkdir -p "$CACHE_DIR"
touch "$USAGE_FILE"

# Orden de prioridad: tus apps de usuario primero, luego las del sistema
APP_DIRS=(
    "$HOME/.local/share/applications"
    "$HOME/.local/share/flatpak/exports/share/applications"
    "/usr/local/share/applications"
    "/usr/share/applications"
    "/var/lib/flatpak/exports/share/applications"
)

get_field() {
    # get_field ARCHIVO CAMPO
    grep -m1 "^${2}=" "$1" 2>/dev/null | cut -d= -f2-
}

clean_exec() {
    # quita los códigos %f %F %u %U %i %c %k etc de la línea Exec
    echo "$1" | sed -E 's/%[a-zA-Z]//g'
}

list_all_apps() {
    local f name name_es exec_cmd icon nodisplay hidden
    for dir in "${APP_DIRS[@]}"; do
        [ -d "$dir" ] || continue
        for f in "$dir"/*.desktop; do
            [ -f "$f" ] || continue
            nodisplay=$(get_field "$f" "NoDisplay")
            hidden=$(get_field "$f" "Hidden")
            [ "$nodisplay" = "true" ] && continue
            [ "$hidden" = "true" ] && continue
            name_es=$(get_field "$f" "Name[es]")
            name=$(get_field "$f" "Name")
            [ -n "$name_es" ] && name="$name_es"
            [ -z "$name" ] && continue
            exec_cmd=$(get_field "$f" "Exec")
            [ -z "$exec_cmd" ] && continue
            icon=$(get_field "$f" "Icon")
            printf '%s\x1e%s\x1e%s\n' "$name" "$icon" "$f"
        done
    done
}

# ---------------------------------------------------------------
# Si rofi nos llama con un argumento => el usuario seleccionó algo
# (Enter, click, o Ctrl+1..5). El archivo .desktop real viaja en
# $ROFI_INFO, no en el texto visible (así el número no lo rompe).
# ---------------------------------------------------------------
if [ -n "${1:-}" ] && [ -n "${ROFI_INFO:-}" ]; then
    target_file="$ROFI_INFO"
    exec_cmd=$(get_field "$target_file" "Exec")
    exec_cmd=$(clean_exec "$exec_cmd")
    terminal=$(get_field "$target_file" "Terminal")

    # actualizar contador de uso
    count=$(awk -F'\t' -v f="$target_file" '$2==f{print $1}' "$USAGE_FILE" | tail -n1)
    count=${count:-0}
    newcount=$((count + 1))
    grep -v -F -- "	${target_file}" "$USAGE_FILE" > "${USAGE_FILE}.tmp" 2>/dev/null || true
    printf '%s\t%s\n' "$newcount" "$target_file" >> "${USAGE_FILE}.tmp"
    mv "${USAGE_FILE}.tmp" "$USAGE_FILE"

    if [ "$terminal" = "true" ]; then
        setsid "${TERMINAL:-kitty}" -e sh -c "$exec_cmd" >/dev/null 2>&1 &
    else
        setsid sh -c "$exec_cmd" >/dev/null 2>&1 &
    fi
    exit 0
fi

# ---------------------------------------------------------------
# Listado inicial: ordenar por uso (desc) y luego alfabético
# ---------------------------------------------------------------
declare -A USAGE
while IFS=$'\t' read -r cnt file; do
    [ -n "${file:-}" ] && USAGE["$file"]="$cnt"
done < "$USAGE_FILE"

declare -A SEEN
apps=()
while IFS=$'\x1e' read -r name icon file; do
    base=$(basename "$file")
    [ -n "${SEEN[$base]:-}" ] && continue
    SEEN["$base"]=1
    usage="${USAGE[$file]:-0}"
    apps+=("$(printf '%09d' "$usage")\x1e${name}\x1e${icon}\x1e${file}")
done < <(list_all_apps)

sorted=$(printf '%b\n' "${apps[@]}" | sort -t $'\x1e' -k1,1r -k2,2)

i=0
while IFS=$'\x1e' read -r usage name icon file; do
    [ -z "${name:-}" ] && continue
    i=$((i + 1))
    if [ "$i" -le 5 ]; then
        label="${i}  ${name}"
    else
        label="    ${name}"
    fi
    if [ -n "$icon" ]; then
        printf '%s\0icon\x1f%s\x1finfo\x1f%s\n' "$label" "$icon" "$file"
    else
        printf '%s\0info\x1f%s\n' "$label" "$file"
    fi
done <<< "$sorted"
