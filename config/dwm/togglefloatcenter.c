/* togglefloatcenter.c
 * Como togglefloating, pero al volverse flotante
 * redimensiona a un tamaño pequeño y lo centra.
 */
void
togglefloatcenter(const Arg *arg)
{
	Client *c = selmon->sel;
	unsigned int w, h, x, y;

	if (!c)
		return;
	if (c->isfullscreen) /* no tocar ventanas en fullscreen real */
		return;

	c->isfloating = !c->isfloating || c->isfixed;

	if (c->isfloating) {
		w = selmon->ww * floatcenterwfact;
		h = selmon->wh * floatcenterhfact;
		x = selmon->mx + (selmon->mw - w) / 2;
		y = selmon->my + (selmon->mh - h) / 2;
		resize(c, x, y, w, h, 0);
	}
	arrange(selmon);
}
