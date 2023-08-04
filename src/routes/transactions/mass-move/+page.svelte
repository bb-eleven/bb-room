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
	import { inou, inout, iu, ninou } from '$lib/utils';
	import type { Nullable } from 'vitest';
	import type { ItemViewMap } from '../../inventory/mod';
	import * as Mod from './mod';
	import type {
		ValidateText,
		ItemViewCreateTransactionDetail,
		LocationCodeQuantity,
	} from '../create/types';
	import * as CreateValidators from '../create/validators';
	import * as Validators from './validators';
	import * as CreateMod from '../create/mod';

	export let data;

	if (inou(data.session) && browser) {
		goto('/login', { state: { redirect: '/transactions/mass-move' }, replaceState: true });
	}

	let itemViews: ItemView['Row'][] = [];
	let author: ValidateText = {};
	let purpose: ValidateText = {};
	let itemViewCreateTransactionDetails: ItemViewCreateTransactionDetail[] = [];

	let fromLocationCodeQuantity: LocationCodeQuantity | undefined = undefined;
	let fromLocationCodeQuantityError: Nullable<string> = null;
	let toLocationCodeQuantity: LocationCodeQuantity | undefined = undefined;
	let toLocationCodeQuantityError: Nullable<string> = null;

	let isValid = false;

	if (browser) {
		const selectedItemViewsStr = localStorage.getItem('selectedItemViews');
		if (ninou(selectedItemViewsStr)) {
			itemViews = Object.values(JSON.parse(selectedItemViewsStr) as ItemViewMap);
			itemViewCreateTransactionDetails = itemViews.map((iv) =>
				CreateMod.mapToItemViewCreateTransactionDetail(
					iv,
					fromLocationCodeQuantity,
					toLocationCodeQuantity,
				),
			);
		}
	}

	const updateAllFromLocationCodes = () =>
		itemViewCreateTransactionDetails.forEach((_ivctd, i) => {
			itemViewCreateTransactionDetails[i].fromLocationCodeQuantity =
				Mod.findLocationCodeQuantityByCode(
					inout(itemViewCreateTransactionDetails[i].locationCodeQuantities, []),
					fromLocationCodeQuantity?.code,
				);
		});
	const updateAllToLocationCodes = () =>
		itemViewCreateTransactionDetails.forEach((_ivctd, i) => {
			itemViewCreateTransactionDetails[i].toLocationCodeQuantity =
				Mod.findLocationCodeQuantityByCode(
					inout(data.locationCodeQuantities, []),
					toLocationCodeQuantity?.code,
				);
		});

	const submit = async () => {
		author = CreateValidators.validateText(author);
		purpose = CreateValidators.validateText(purpose);

		fromLocationCodeQuantityError = Validators.validateLocationCode(fromLocationCodeQuantity);
		toLocationCodeQuantityError = Validators.validateLocationCode(toLocationCodeQuantity);

		isValid =
			CreateValidators.validateTextHasNoError(author) &&
			CreateValidators.validateTextHasNoError(purpose) &&
			inou(fromLocationCodeQuantityError) &&
			inou(toLocationCodeQuantityError);

		itemViewCreateTransactionDetails = itemViewCreateTransactionDetails.map((ivctd) => {
			ivctd = CreateValidators.validateItemViewCreateTransactionDetail(ivctd);
			isValid &&= CreateValidators.itemViewCreateTransactionDetailHasNoError(ivctd);
			return ivctd;
		});

		if (!isValid) {
			return;
		}

		// Author is validated above
		const { data: transactionId, error } = await CreateMod.createTransaction(
			data.supabase,
			author as any,
			purpose as any,
			itemViewCreateTransactionDetails,
		);

		console.log(transactionId, error);

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
	<section class="mt-4 space-y-4 h-[80%] overflow-y-scroll">
		<Input
			label="Author"
			bind:value={author.value}
			error={author.error}
			onBlur={() => (author = CreateValidators.validateText(author))}
		/>
		<Input
			label="Purpose"
			bind:value={purpose.value}
			error={purpose.error}
			onBlur={() => (purpose = CreateValidators.validateText(purpose))}
		/>
		<SingleSelect
			label="From location"
			options={data.locationCodeQuantities.filter(
				({ code }) => code !== toLocationCodeQuantity?.code,
			)}
			getInputText={Mod.getLocationCodesInputDisplay}
			getOptionText={Mod.getLocationCodesOptionDisplay}
			bind:selected={fromLocationCodeQuantity}
			error={fromLocationCodeQuantityError}
			onBlur={() => {
				fromLocationCodeQuantityError = Validators.validateLocationCode(fromLocationCodeQuantity);
				updateAllFromLocationCodes();
			}}
		/>

		<SingleSelect
			label="To location"
			options={data.locationCodeQuantities.filter(
				({ code }) => code !== fromLocationCodeQuantity?.code,
			)}
			getInputText={Mod.getLocationCodesInputDisplay}
			getOptionText={Mod.getLocationCodesOptionDisplay}
			bind:selected={toLocationCodeQuantity}
			error={toLocationCodeQuantityError}
			onBlur={() => {
				toLocationCodeQuantityError = Validators.validateLocationCode(toLocationCodeQuantity);
				updateAllToLocationCodes();
			}}
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
						label={CreateMod.formatQuantityLabel(ivctd.fromLocationCodeQuantity)}
						bind:value={ivctd.quantity}
						error={ivctd.errors.quantity}
						max={CreateMod.getMaxQuantity(ivctd.fromLocationCodeQuantity)}
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
