<script lang="ts">
	import { browser } from '$app/environment';
	import CollapsibleView from '$lib/components/CollapsibleView.svelte';
	import Title from '$lib/components/Title.svelte';
	import TextButton from '$lib/components/buttons/TextButton.svelte';
	import Input from '$lib/components/inputs/Input.svelte';
	import NumberInput from '$lib/components/inputs/NumberInput.svelte';
	import SingleSelect from '$lib/components/inputs/selects/SingleSelect.svelte';
	import type { ItemView } from '$lib/database.types.short';
	import { inou, iu, ninou } from '$lib/utils';
	import * as Mod from './mod';
	import type { Author, ItemViewCreateTransactionDetail } from './types';
	import * as Validators from './validators';

	export let data;
	let itemViews: ItemView['Row'][] = [];
	let author: Author = {};
	let v: ItemViewCreateTransactionDetail[] = [];

	if (browser) {
		const selectedItemViewsStr = localStorage.getItem('selectedItemViews');
		if (ninou(selectedItemViewsStr)) {
			itemViews = JSON.parse(selectedItemViewsStr);
			v = itemViews.map(Mod.mapToItemViewCreateTransactionDetail);
			console.log(v);
		}
	}

	const submit = () => {
		author = Validators.validateAuthor(author);
		v = v.map(Validators.validateItemViewCreateTransactionDetail);
	};
</script>

<!-- TODO: remove negative margin, 100vh(?) -->
<div class="relative w-full h-[100vh] bg-off-100 p-3 mt-[-0.5rem]">
	<div class="relative flex items-end gap-2">
		<Title title="Create Transaction" />
	</div>

	<section class="mt-4 h-[80vh] overflow-y-scroll">
		<Input
			label="Author"
			bind:value={author.value}
			error={author.error}
			onBlur={() => (author = Validators.validateAuthor(author))}
			class="mb-4"
		/>
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
							getInputText={Mod.getLocationCodesInputDisplay}
							getOptionText={Mod.getLocationCodesOptionDisplay}
							bind:selected={vv.from_location_code}
							error={vv.errors.from_location_code}
							onBlur={() =>
								(vv = Validators.validateItemViewCreateTransactionDetailFieldRequired(
									vv,
									'from_location_code',
									iu,
								))}
						/>

						<SingleSelect
							label="To location"
							options={data.locationCodes.filter(
								(toLocationCode) => toLocationCode !== vv.from_location_code,
							)}
							getInputText={Mod.getLocationCodesInputDisplay}
							getOptionText={Mod.getLocationCodesOptionDisplay}
							bind:selected={vv.to_location_code}
							error={vv.errors.to_location_code}
							onBlur={() =>
								(vv = Validators.validateItemViewCreateTransactionDetailFieldRequired(
									vv,
									'to_location_code',
									iu,
								))}
						/>
					</div>
					<NumberInput
						label="Quantity"
						bind:value={vv.quantity}
						error={vv.errors.quantity}
						onBlur={() =>
							(vv = Validators.validateItemViewCreateTransactionDetailFieldRequired(
								vv,
								'quantity',
								inou,
							))}
						class="w-1/2 mt-4"
					/>
				</div></CollapsibleView
			>
		{/each}
	</section>

	<div class="absolute bottom-0 w-[calc(100%-1.5rem)] py-3 bg-off-100">
		<TextButton text="Submit" click={submit} />
	</div>
</div>
