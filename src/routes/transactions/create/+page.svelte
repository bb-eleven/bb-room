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
	import type { ItemViewMap } from '../../inventory/mod';
	import * as Mod from './mod';
	import type { Author, ItemViewCreateTransactionDetail } from './types';
	import * as Validators from './validators';

	export let data;

	if (inou(data.session) && browser) {
		goto('/login', { state: { redirect: '/transactions/create' }, replaceState: true });
	}

	let itemViews: ItemView['Row'][] = [];
	let author: Author = {};
	let itemViewCreateTransactionDetails: ItemViewCreateTransactionDetail[] = [];
	let isValid = false;

	if (browser) {
		const selectedItemViewsStr = localStorage.getItem('selectedItemViews');
		if (ninou(selectedItemViewsStr)) {
			itemViews = Object.values(JSON.parse(selectedItemViewsStr) as ItemViewMap);
			itemViewCreateTransactionDetails = itemViews.map((iv) =>
				Mod.mapToItemViewCreateTransactionDetail(iv),
			);
		}
	}

	const submit = async () => {
		author = Validators.validateAuthor(author);
		isValid = Validators.authorHasNoError(author);

		itemViewCreateTransactionDetails = itemViewCreateTransactionDetails.map((ivctd) => {
			ivctd = Validators.validateItemViewCreateTransactionDetail(ivctd);
			isValid &&= Validators.itemViewCreateTransactionDetailHasNoError(ivctd);
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
	<section class="mt-4 h-[80%] overflow-y-scroll">
		<Input
			label="Author"
			bind:value={author.value}
			error={author.error}
			onBlur={() => (author = Validators.validateAuthor(author))}
			class="mb-4"
		/>
		{#each itemViewCreateTransactionDetails as ivctd}
			<CollapsibleView class="mb-4">
				<svelte:fragment slot="title">
					<span class="text-off-800">{ivctd.name}</span>
					{#if ninou(ivctd.variant_name)}
						<span class="text-brown-600 ml-2">[{ivctd.variant_name}]</span>
					{/if}
				</svelte:fragment>

				<div slot="body" class="p-4">
					<div class="grid grid-cols-2 gap-4">
						<SingleSelect
							label="From location"
							options={ivctd.locationCodeQuantities.filter(
								(fromLocationCode) => fromLocationCode !== ivctd.toLocationCodeQuantity,
							)}
							getInputText={Mod.getLocationCodesInputDisplay}
							getOptionText={Mod.getLocationCodesOptionDisplay}
							bind:selected={ivctd.fromLocationCodeQuantity}
							error={ivctd.errors.fromLocationCodeQuantity}
							onBlur={() =>
								(ivctd = Validators.validateItemViewCreateTransactionDetailFieldRequired(
									ivctd,
									'fromLocationCodeQuantity',
									iu,
								))}
						/>

						<SingleSelect
							label="To location"
							options={ivctd.locationCodeQuantities.filter(
								({ code }) => code !== ivctd.fromLocationCodeQuantity?.code,
							)}
							getInputText={Mod.getLocationCodesInputDisplay}
							getOptionText={Mod.getLocationCodesOptionDisplay}
							bind:selected={ivctd.toLocationCodeQuantity}
							error={ivctd.errors.toLocationCodeQuantity}
							onBlur={() =>
								(ivctd = Validators.validateItemViewCreateTransactionDetailFieldRequired(
									ivctd,
									'toLocationCodeQuantity',
									iu,
								))}
						/>
					</div>
					<NumberInput
						label={Mod.formatQuantityLabel(ivctd.fromLocationCodeQuantity)}
						bind:value={ivctd.quantity}
						error={ivctd.errors.quantity}
						max={Mod.getMaxQuantity(ivctd.fromLocationCodeQuantity)}
						onBlur={() =>
							(ivctd = Validators.validateItemViewCreateTransactionDetailFieldRequired(
								ivctd,
								'quantity',
								inou,
							))}
						class="w-3/4 md:w-1/2 mt-4"
					/>
				</div></CollapsibleView
			>
		{/each}
	</section>

	<div class="absolute bottom-0 w-[calc(100%-1.5rem)] py-3 bg-off-100">
		<TextButton text="Submit" click={submit} />
	</div>
{/if}
