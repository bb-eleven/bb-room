export const inou = <T>(value: T | null | undefined): value is null | undefined =>
	value === null || value === undefined;

export const ninou = <T>(value: T | null | undefined): value is T => !inou(value);
