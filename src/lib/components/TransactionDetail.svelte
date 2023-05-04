<script lang="ts">
	import type { TransactionDetail } from '$lib/db/tables';
	import type { ItemView } from '$lib/db/views';
	import { inou } from '$lib/utils';
	import Dropdown from './Dropdown.svelte';

	export let itemViews: ItemView[];
	export let selectedItem: ItemView | undefined;
	export let onRemove = () => {};

	let itemLabel = 'Item';
	let fromLocationOptions: LocationOption[];
	let toLocationOptions: LocationOption[];

	$: {
		itemLabel = inou(selectedItem) ? 'Item' : `Item: ${createItemLabel(selectedItem)}`;
		fromLocationOptions = createFromLocationOptions(toLocation);
		toLocationOptions = createToLocationOptions(fromLocation);
	}

	const createItemLabel = (itemView?: ItemView) => {
		const { name, variant_name, category_names } = itemView as any;
		return (
			(inou(variant_name) ? name : `${name} (${variant_name})`) + `; ${category_names?.join(', ')}`
		);
	};

	let fromLocationLabel = 'From';
	$: {
		if (inou(fromLocation)) {
			fromLocationLabel = 'From';
		} else {
			const { code, quantity } = fromLocation;
			fromLocationLabel = `From "${code}"${inou(quantity) ? '' : '; qty: ' + quantity}`;
		}
	}
	let toLocationLabel = 'To';
	$: {
		if (inou(toLocation)) {
			toLocationLabel = 'To';
		} else {
			const { code, quantity } = toLocation;
			toLocationLabel = `To "${code}"${inou(quantity) ? '' : '; qty: ' + quantity}`;
		}
	}

	const outside = 'Outside';
	type LocationOption = { code: string; quantity?: number };
	let fromLocation: LocationOption;
	let toLocation: LocationOption;

	const createFromLocationOptions = (toLocation: LocationOption): LocationOption[] => {
		if (inou(selectedItem)) {
			return [null as any];
		}
		const { location_codes, location_quantities } = selectedItem;
		return (toLocation?.code === outside ? [] : [{ code: outside }]).concat(
			mapLocationOptions(location_codes, location_quantities),
		);
	};
	const createToLocationOptions = (fromLocation: LocationOption): LocationOption[] => {
		if (inou(selectedItem)) {
			return [null as any];
		}
		const { location_codes, location_quantities } = selectedItem;
		return (fromLocation?.code === outside ? [] : [{ code: outside }]).concat(
			mapLocationOptions(location_codes, location_quantities),
		);
	};
	const mapLocationOptions = (location_codes?: string[], location_quantities?: number[]) => {
		return location_codes?.map((code, i) => ({ code, quantity: location_quantities?.[i] })) ?? [];
	};
	const getLocationOptionName = (locationOption: LocationOption) => {
		if (inou(locationOption)) {
			return 'Select item first!';
		}
		const { code, quantity } = locationOption;
		return `${code}: ${quantity ?? '-'}`;
	};
</script>

<!--
  TODO
  - Export TransactionDetail instead of ItemView
  - Quantity
  - Errors
    - Quantity more than available
    - Quantity less than 1
 -->
<div class="bg-mirage-lighter p-2 space-y-2 rounded-md">
	<Dropdown
		label={itemLabel}
		options={itemViews}
		getName={createItemLabel}
		bind:selected={selectedItem}
	/>
	<Dropdown
		label={fromLocationLabel}
		options={fromLocationOptions}
		getName={getLocationOptionName}
		bind:selected={fromLocation}
	/>
	<Dropdown
		label={toLocationLabel}
		options={toLocationOptions}
		getName={getLocationOptionName}
		bind:selected={toLocation}
	/>
	<div class="flex justify-end p-1">
		<button on:click={onRemove} class="bg-mirage-lightest rounded-lg px-2 py-1"> Remove </button>
	</div>
</div>
