import { iu } from '$lib/utils';
import type { Nullable } from 'vitest';

export const validateLocationCode = (locationCode: Nullable<string>): Nullable<string> => {
	return iu(locationCode) ? 'Required' : null;
};
