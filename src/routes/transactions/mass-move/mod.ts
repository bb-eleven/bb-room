import { iu } from '$lib/utils';
import type { Nullable } from 'vitest';
import type { LocationCodeQuantity } from '../create/types';

export const findLocationCodeQuantityByCode = (
	locationCodeQuantities: LocationCodeQuantity[],
	code: Nullable<string>,
) => locationCodeQuantities.find((lcq) => lcq.code === code);

export const getLocationCodesInputDisplay = (selected?: LocationCodeQuantity) => {
	return iu(selected) ? 'Select' : selected.code === null ? 'Outside' : selected.code;
};

export const getLocationCodesOptionDisplay = (selected?: LocationCodeQuantity) => {
	return iu(selected) ? 'Select' : selected.code === null ? 'Outside' : selected.code;
};
