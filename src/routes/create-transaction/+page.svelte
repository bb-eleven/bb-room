<script lang="ts">
	import { goto } from '$app/navigation';
	import Button from '$lib/components/Button.svelte';
	import CheckboxDropdown from '$lib/components/CheckboxDropdown.svelte';
	import SearchBar from '$lib/components/SearchBar.svelte';
	import TransactionDetail from '$lib/components/TransactionDetail.svelte';
	import { createTransaction } from '$lib/db/create-transaction.js';
	import { DbFunction } from '$lib/db/functions.js';
	import type { Category, Location, CreateTransactionDetail } from '$lib/db/tables';
	import { type ItemView, DbView } from '$lib/db/views.js';
	import { supabase } from '$lib/supabase-client.js';
	import { inou, ninou } from '$lib/utils.js';

	export let data;

	let author: string;
	let authorError: { message: string } | undefined;

	let itemName: string;
	let categoriesLabel = 'Categories';
	let selectedCategories: Category[] = [];
	$: categoriesLabel =
		selectedCategories.length === 0
			? 'Categories'
			: 'Categories: ' + selectedCategories.map(({ name }) => name).join(', ');

	let locationsLabel = 'Locations';
	let selectedLocations: Location[] = [];
	$: locationsLabel =
		selectedLocations.length === 0
			? 'Locations'
			: 'Locations: ' + selectedLocations.map(({ code }) => code).join(', ');

	let itemViews: ItemView[] = [];

	(async () => {
		const { data, error } = await supabase.from(DbView.Item).select();
		itemViews = data as ItemView[];
	})();

	const search = async () => {
		const { data, error } = await supabase
			.rpc(DbFunction.FilterItemView, {
				_name_query: `%${itemName ?? ''}%`,
				_category_names: selectedCategories.map(({ name }) => name),
				_location_codes: selectedLocations.map(({ code }) => code),
			})
			.select();
		itemViews = data as ItemView[];
	};

	let selectedItems: (ItemView | undefined)[] = [undefined];
	let createTransactionDetails: CreateTransactionDetail[] = [{}];
	let createTransactionDetailsErrors: ({ messages: string[] } | undefined)[] = [];

	const addItem = () => {
		selectedItems.push(undefined);
		selectedItems = selectedItems;
		createTransactionDetails.push({});
		console.log(createTransactionDetails);
		createTransactionDetails = createTransactionDetails;
		createTransactionDetailsErrors.push(undefined);
		createTransactionDetailsErrors = createTransactionDetailsErrors;
	};

	const removeItem = (index: number) => {
		selectedItems.splice(index, 1);
		selectedItems = selectedItems;
		createTransactionDetails.splice(index, 1);
		createTransactionDetails = createTransactionDetails;
		createTransactionDetailsErrors.splice(index, 1);
		createTransactionDetailsErrors = createTransactionDetailsErrors;
	};

	const validateAuthor = () => {
		authorError =
			inou(author) || author.trim() === '' ? { message: 'Author cannot be null!' } : undefined;
	};

	const validateCreateTransactionDetail = (ctd: CreateTransactionDetail, index: number) => {
		// const ctd = createTransactionDetails[index];
		let messages = [];

		if (inou(ctd.item_id)) {
			messages.push('Item cannot be empty!');
		}
		if (ctd.from_location_code === undefined) {
			messages.push('From Location cannot be empty!');
		}
		if (ctd.to_location_code === undefined) {
			messages.push('To Location cannot be empty!');
		}
		if (inou(ctd.quantity)) {
			messages.push('Quantity cannot be empty!');
		}

		createTransactionDetailsErrors[index] = messages.length === 0 ? undefined : { messages };
	};
	const submit = async () => {
		validateAuthor();
		createTransactionDetails.forEach(validateCreateTransactionDetail);

		if (inou(authorError) && createTransactionDetailsErrors.filter(ninou).length === 0) {
			createTransaction(author, createTransactionDetails);
			createTransactionDetails = [{}];
			selectedItems = [undefined];
		}
	};
</script>

<!--
  TODO
  - Collapsible filter
-->
<div id="filter" class="mx-auto w-1/2 space-y-2">
	<SearchBar bind:search={itemName} />
	<CheckboxDropdown
		label={categoriesLabel}
		options={data.categories}
		getName={(item) => item.name}
		bind:selected={selectedCategories}
	/>
	<CheckboxDropdown
		label={locationsLabel}
		options={data.locations}
		getName={(item) => item.code}
		bind:selected={selectedLocations}
	/>
	<div class="pt-2 flex justify-center">
		<Button text="Search" click={search} />
	</div>
	<span class="block mt-4 text-center">{itemViews.length} results found</span>
</div>

<div class="mt-4 space-y-4">
	<SearchBar bind:search={author} placeholder="Author" onBlur={validateAuthor} />
	{#if !inou(authorError)}
		<div class="rounded-lg p-2 bg-red text-cultured">
			{authorError.message}
		</div>
	{/if}

	{#each selectedItems as selectedItem, i}
		<TransactionDetail
			showRemoveButton={i > 0}
			onRemove={() => removeItem(i)}
			{itemViews}
			{selectedItem}
			error={createTransactionDetailsErrors[i]}
			bind:createTransactionDetail={createTransactionDetails[i]}
		/>
	{/each}
	<Button text="Add item" click={addItem} />
</div>

<div class="my-2 w-full flex justify-center">
	<button class="rounded-xl px-5 py-2 bg-envy text-mirage" on:click={submit}> Submit </button>
</div>
