/* dragmfact.c
 * Redimensiona el layout arrastrando el mouse (como Mod+H / Mod+L,
 * pero con el mouse en vez del teclado). Cambia selmon->mfact en vivo.
 */
void
dragmfact(const Arg *arg)
{
	float f;
	XEvent ev;
	Time lasttime = 0;

	if (!selmon->sel || !selmon->lt[selmon->sellt]->arrange)
		return; /* solo tiene sentido en layouts con arrange (tile) */

	if (XGrabPointer(dpy, root, False, MOUSEMASK, GrabModeAsync, GrabModeAsync,
		None, cursor[CurResize]->cursor, CurrentTime) != GrabSuccess)
		return;

	do {
		XMaskEvent(dpy, MOUSEMASK|ExposureMask|SubstructureRedirectMask, &ev);
		switch (ev.type) {
		case ConfigureRequest:
		case Expose:
		case MapRequest:
			handler[ev.type](&ev);
			break;
		case MotionNotify:
			if ((ev.xmotion.time - lasttime) <= (1000 / 60))
				continue;
			lasttime = ev.xmotion.time;

			f = (float)(ev.xmotion.x - selmon->wx) / (float)selmon->ww;
			if (f < 0.05)
				f = 0.05;
			if (f > 0.95)
				f = 0.95;
			if (f != selmon->mfact) {
				selmon->mfact = f;
				arrange(selmon);
			}
			break;
		}
	} while (ev.type != ButtonRelease);

	XUngrabPointer(dpy, CurrentTime);
}
