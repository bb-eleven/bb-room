import { iu } from '$lib/utils';
import type { Nullable } from 'vitest';
import type { LocationCodeQuantity } from '../create/types';

export const validateLocationCode = (
	locationCode: Nullable<LocationCodeQuantity>,
): Nullable<string> => {
	return iu(locationCode) ? 'Required' : null;
};
