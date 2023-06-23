export interface RotatingIconData {
	animate: boolean;
	rotated: boolean;
}

export const defaultRotatingIconData = (): RotatingIconData => ({
	animate: false,
	rotated: false,
});

export const rotateIcon = (data: RotatingIconData): RotatingIconData => {
	data.animate = true;
	data.rotated = !data.rotated;
	return data;
};
