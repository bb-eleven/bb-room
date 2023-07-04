<script lang="ts">
	import { browser } from '$app/environment';
	import CollapsibleView from '$lib/components/CollapsibleView.svelte';
	import Title from '$lib/components/Title.svelte';
	import TextButton from '$lib/components/buttons/TextButton.svelte';
	import Input from '$lib/components/inputs/Input.svelte';
	import NumberInput from '$lib/components/inputs/NumberInput.svelte';
	import SingleSelect from '$lib/components/inputs/selects/SingleSelect.svelte';
	import type { ItemView } from '$lib/database.types.short';
	import { ninou } from '$lib/utils';
	import * as Mod from './mod';

	export let data;
	let itemViews: ItemView['Row'][] = [];
	let createTransactionDetails: Mod.CreateTransactionDetail[] = [];
	let v: Mod.ItemViewCreateTransactionDetail[] = [];

	if (browser) {
		const selectedItemViewsStr = localStorage.getItem('selectedItemViews');
		if (ninou(selectedItemViewsStr)) {
			itemViews = JSON.parse(selectedItemViewsStr);
			v = itemViews.map(Mod.mapToItemViewCreateTransactionDetail);
			console.log(v);
		}
	}

	$: console.log(v);
</script>

<!-- TODO: remove negative margin, 100vh(?) -->
<div class="relative w-full h-[100vh] bg-off-100 p-3 mt-[-0.5rem]">
	<div class="relative flex items-end gap-2">
		<Title title="Create Transaction" />
	</div>

	<section class="mt-4 h-[80vh] overflow-y-scroll">
		<Input label="Author" class="mb-4" />
		{#each v as vv}
			<CollapsibleView class="mb-4">
				<svelte:fragment slot="title">
					<span class="text-off-800">{vv.name}</span>
					{#if ninou(vv.variant_name)}
						<span class="text-brown-600 ml-2">[{vv.variant_name}]</span>
					{/if}
				</svelte:fragment>

				<div slot="body" class="p-3">
					<div class="grid grid-cols-2 gap-4">
						<SingleSelect
							label="From location"
							options={vv.from_location_codes.filter(
								(fromLocationCode) => fromLocationCode !== vv.to_location_code,
							)}
							getInputText={Mod.getFromLocationsInputDisplay}
							getOptionText={(option) => option}
							bind:selected={vv.from_location_code}
						/>

						<SingleSelect
							label="To location"
							options={data.locations.filter(
								({ code: toLocationCode }) => toLocationCode !== vv.from_location_code,
							)}
							getInputText={Mod.getToLocationsInputDisplay}
							getOptionText={(option) => option?.code}
							selected={undefined}
							select={(selected) => (vv.to_location_code = selected.code)}
						/>
					</div>
					<NumberInput label="Quantity" bind:value={vv.quantity} class="w-1/2 mt-4" />
				</div></CollapsibleView
			>
		{/each}
	</section>

	<div class="absolute bottom-0 w-[calc(100%-1.5rem)] py-3 bg-off-100">
		<TextButton text="Submit" />
	</div>
</div>
