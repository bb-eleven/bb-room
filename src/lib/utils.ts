export type ArrayElement<ArrayType extends readonly unknown[]> =
	ArrayType extends readonly (infer T)[] ? T : never;

export const iu = <T>(value: T | undefined): value is undefined => value === undefined;

export const inou = <T>(value: T | null | undefined): value is null | undefined =>
	value === null || value === undefined;

export const ninou = <T>(value: T | null | undefined): value is T => !inou(value);

// returns value if not null or undefined, else returns then
export const inout = <T>(value: T | null | undefined, then: T): T => (inou(value) ? then : value);
