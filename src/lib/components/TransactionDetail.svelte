<script lang="ts">
	import type { TransactionDetail } from '$lib/db/tables';
	import type { ItemView } from '$lib/db/views';
	import { inou } from '$lib/utils';
	import Dropdown from './Dropdown.svelte';

	export let itemViews: ItemView[];
	export let selectedItem: ItemView | undefined;
	let itemLabel = 'Item';
	$: {
		itemLabel = inou(selectedItem) ? 'Item' : `Item: ${createItemLabel(selectedItem)}`;
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

	const createFromLocationOptions = (itemView?: ItemView): LocationOption[] => {
		if (inou(itemView)) {
			return [null as any];
		}
		const { location_codes, location_quantities } = itemView;
		return (toLocation?.code === outside ? [] : [{ code: outside }]).concat(
			mapLocationOptions(location_codes, location_quantities),
		);
	};
	const createToLocationOptions = (itemView?: ItemView): LocationOption[] => {
		if (inou(itemView)) {
			return [null as any];
		}
		const { location_codes, location_quantities } = itemView;
		console.log(toLocation);
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
  - Remove button
  - Export TransactionDetail instead of ItemView
  - Quantity
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
		options={createFromLocationOptions(selectedItem)}
		getName={getLocationOptionName}
		bind:selected={fromLocation}
	/>
	<Dropdown
		label={toLocationLabel}
		options={createToLocationOptions(selectedItem)}
		getName={getLocationOptionName}
		bind:selected={toLocation}
	/>
</div>
