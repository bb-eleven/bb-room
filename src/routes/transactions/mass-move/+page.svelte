<script lang="ts">
	import { browser } from '$app/environment';
	import { goto } from '$app/navigation';
	import CollapsibleView from '$lib/components/CollapsibleView.svelte';
	import Title from '$lib/components/Title.svelte';
	import TextButton from '$lib/components/buttons/TextButton.svelte';
	import Input from '$lib/components/inputs/Input.svelte';
	import NumberInput from '$lib/components/inputs/NumberInput.svelte';
	import SingleSelect from '$lib/components/inputs/selects/SingleSelect.svelte';
	import type { ItemView } from '$lib/database.types.short';
	import { inou, iu, ninou } from '$lib/utils';
	import type { Nullable } from 'vitest';
	import type { ItemViewMap } from '../../inventory/mod';
	import * as Mod from '../create/mod';
	import type { Author, ItemViewCreateTransactionDetail } from '../create/types';
	import * as CreateValidators from '../create/validators';
	import * as Validators from './validators';

	export let data;

	if (inou(data.session) && browser) {
		goto('/login', { state: { redirect: '/transactions/mass-move' }, replaceState: true });
	}

	let itemViews: ItemView['Row'][] = [];
	let author: Author = {};
	let itemViewCreateTransactionDetails: ItemViewCreateTransactionDetail[] = [];

	let fromLocationCode: Nullable<string> = undefined;
	let fromLocationCodeError: Nullable<string> = null;
	let toLocationCode: Nullable<string> = undefined;
	let toLocationCodeError: Nullable<string> = null;

	let isValid = false;

	if (browser) {
		const selectedItemViewsStr = localStorage.getItem('selectedItemViews');
		if (ninou(selectedItemViewsStr)) {
			itemViews = Object.values(JSON.parse(selectedItemViewsStr) as ItemViewMap);
			itemViewCreateTransactionDetails = itemViews.map((iv) =>
				Mod.mapToItemViewCreateTransactionDetail(iv, fromLocationCode, toLocationCode),
			);
		}
	}

	$: itemViewCreateTransactionDetails.forEach(
		(_ivctd, i) =>
			(itemViewCreateTransactionDetails[i].from_location_code = fromLocationCode as string),
	);
	$: itemViewCreateTransactionDetails.forEach(
		(_ivctd, i) =>
			(itemViewCreateTransactionDetails[i].to_location_code = toLocationCode as string),
	);

	const submit = async () => {
		console.log(itemViewCreateTransactionDetails);
		author = CreateValidators.validateAuthor(author);

		fromLocationCodeError = Validators.validateLocationCode(fromLocationCode);
		toLocationCodeError = Validators.validateLocationCode(toLocationCode);

		isValid =
			CreateValidators.authorHasNoError(author) &&
			inou(fromLocationCodeError) &&
			inou(toLocationCodeError);

		itemViewCreateTransactionDetails = itemViewCreateTransactionDetails.map((ivctd) => {
			ivctd = CreateValidators.validateItemViewCreateTransactionDetail(ivctd);
			isValid &&= CreateValidators.itemViewCreateTransactionDetailHasNoError(ivctd);
			return ivctd;
		});

		if (!isValid) {
			return;
		}

		// Author is validated above
		const { data: transactionId, error } = await Mod.createTransaction(
			data.supabase,
			author as any,
			itemViewCreateTransactionDetails,
		);

		if (browser) {
			localStorage.removeItem('selectedItemViews');
		}

		// TODO: Go to new page
		if (browser) {
			goto('/inventory');
		}
	};
</script>

<div class="flex items-end gap-2">
	<Title title="Create Transaction" />
</div>

{#if itemViewCreateTransactionDetails.length === 0}
	<section class="mt-40">
		<p class="text-lg mb-2">There are no selected items.</p>
		<TextButton text="Go to Inventory" click={() => goto('/inventory')} />
	</section>
{:else}
	<section class="mt-4 space-y-4 h-[80%] overflow-y-scroll">
		<Input
			label="Author"
			bind:value={author.value}
			error={author.error}
			onBlur={() => (author = CreateValidators.validateAuthor(author))}
		/>
		<SingleSelect
			label="From location"
			options={data.locationCodes.filter((fromLocationCode) => fromLocationCode !== toLocationCode)}
			getInputText={Mod.getLocationCodesInputDisplay}
			getOptionText={Mod.getLocationCodesOptionDisplay}
			bind:selected={fromLocationCode}
			error={fromLocationCodeError}
			onBlur={() => (fromLocationCodeError = Validators.validateLocationCode(fromLocationCode))}
		/>

		<SingleSelect
			label="To location"
			options={data.locationCodes.filter((toLocationCode) => toLocationCode !== fromLocationCode)}
			getInputText={Mod.getLocationCodesInputDisplay}
			getOptionText={Mod.getLocationCodesOptionDisplay}
			bind:selected={toLocationCode}
			error={toLocationCodeError}
			onBlur={() => (toLocationCodeError = Validators.validateLocationCode(toLocationCode))}
		/>

		{#each itemViewCreateTransactionDetails as ivctd}
			<CollapsibleView class="mt-4">
				<svelte:fragment slot="title">
					<span class="text-off-800">{ivctd.name}</span>
					{#if ninou(ivctd.variant_name)}
						<span class="text-brown-600 ml-2">[{ivctd.variant_name}]</span>
					{/if}
				</svelte:fragment>

				<div slot="body" class="p-4">
					<div class="grid grid-cols-2 gap-4" />
					<NumberInput
						label="Quantity"
						bind:value={ivctd.quantity}
						error={ivctd.errors.quantity}
						onBlur={() =>
							(ivctd = CreateValidators.validateItemViewCreateTransactionDetailFieldRequired(
								ivctd,
								'quantity',
								inou,
							))}
						class="w-3/4 md:w-1/2"
					/>
				</div></CollapsibleView
			>
		{/each}
	</section>

	<div class="absolute bottom-0 w-[calc(100%-1.5rem)] py-3 bg-off-100">
		<TextButton text="Submit" click={submit} />
	</div>
{/if}
