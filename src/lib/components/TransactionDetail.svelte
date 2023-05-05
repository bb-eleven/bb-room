<script lang="ts">
	import type { CreateTransactionDetail } from '$lib/db/tables';
	import type { ItemView } from '$lib/db/views';
	import { inou } from '$lib/utils';
	import Dropdown from './Dropdown.svelte';

	export let itemViews: ItemView[];
	export let showRemoveButton = true;
	export let onRemove = () => {};
	export let selectedItem: ItemView | undefined;
	export let createTransactionDetail: CreateTransactionDetail = {};
	export let error: { messages: string[] } | undefined;
	export let locations: LocationOption[];

	let itemId: number | undefined;
	let previousSelectedItemId: number | undefined;
	let quantity: number | undefined;
	let fromLocation: LocationOption | undefined;
	let toLocation: LocationOption | undefined;

	let fromLocationOptions: LocationOption[] = [];
	let toLocationOptions: LocationOption[] = [];
	type LocationOption = { code: string; quantity?: number };

	let itemLabel = 'Item';
	let fromLocationLabel = 'From';
	let toLocationLabel = 'To';

	$: {
		itemId = selectedItem?.id;
		itemLabel = inou(selectedItem) ? 'Item' : `Item: ${createItemLabel(selectedItem)}`;
		if (previousSelectedItemId !== itemId) {
			fromLocation = undefined;
			toLocation = undefined;
		}
		previousSelectedItemId = itemId;
	}

	$: {
		const fromLocationCode = fromLocation?.code;
		createTransactionDetail = {
			...createTransactionDetail,
			item_id: itemId,
			from_location_code: fromLocationCode === outside ? null : fromLocationCode,
			to_location_code: toLocation?.code,
		};
	}

	$: {
		fromLocationOptions = createFromLocationOptions(toLocation, selectedItem);
		toLocationOptions = createToLocationOptions(fromLocation, selectedItem);
	}

	const createItemLabel = (itemView?: ItemView) => {
		const { name, variant_name, category_names } = itemView as any;
		return (
			(inou(variant_name) ? name : `${name} (${variant_name})`) + `; ${category_names?.join(', ')}`
		);
	};

	$: {
		if (inou(fromLocation)) {
			fromLocationLabel = 'From';
		} else {
			const { code, quantity } = fromLocation;
			fromLocationLabel = `From "${code}"${inou(quantity) ? '' : '; qty: ' + quantity}`;
		}
	}
	$: {
		if (inou(toLocation)) {
			toLocationLabel = 'To';
		} else {
			const { code, quantity } = toLocation;
			toLocationLabel = `To "${code}"${inou(quantity) ? '' : '; qty: ' + quantity}`;
		}
	}

	const outside = 'Outside';

	const createFromLocationOptions = (
		toLocation?: LocationOption,
		selectedItem?: ItemView,
	): LocationOption[] => {
		if (inou(selectedItem)) {
			return [null as any];
		}
		const { location_codes, location_quantities } = selectedItem;
		return (toLocation?.code === outside ? [] : [{ code: outside }]).concat(
			mapLocationOptions(location_codes, location_quantities),
		);
	};
	const createToLocationOptions = (
		fromLocation?: LocationOption,
		selectedItem?: ItemView,
	): LocationOption[] => {
		if (inou(selectedItem)) {
			return [null as any];
		}
		const { location_codes, location_quantities } = selectedItem;
		for (let location of locations) {
			const itemLocationCodeIndex = location_codes?.indexOf(location.code) ?? -1;
			if (itemLocationCodeIndex !== -1) {
				location.quantity = location_quantities?.[itemLocationCodeIndex];
			}
		}
		return (fromLocation?.code === outside ? [] : [{ code: outside }]).concat(locations);
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

	const onQuantityBlur = (event: any) => {
		const value = event.target.value;
		if (value !== '') {
			quantity = Number(value);
		}
	};
</script>

<!--
  TODO
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
	<div class="flex justify-between py-1">
		<label>
			<input
				type="number"
				placeholder="Quantity"
				bind:value={createTransactionDetail.quantity}
				class="w-full bg-mirage placeholder:text-comet-darker text-comet select-none rounded-lg p-1 pl-2 active:outline-none focus:outline-none"
			/>
		</label>
		{#if showRemoveButton}
			<button on:click={onRemove} class="bg-mirage-lightest rounded-lg px-2 py-1"> Remove </button>
		{/if}
	</div>
	{#if !inou(error)}
		<div class="rounded-lg p-2 bg-red text-cultured">
			{#each error.messages as message}
				<div>{message}</div>
			{/each}
		</div>
	{/if}
</div>
