<script lang="ts">
	import Button from '$lib/components/Button.svelte';
	import CheckboxDropdown from '$lib/components/CheckboxDropdown.svelte';
	import SearchBar from '$lib/components/SearchBar.svelte';
	import TransactionDetail from '$lib/components/TransactionDetail.svelte';
	import { DbFunction } from '$lib/db/functions.js';
	import type { Category, Location, CreateTransactionDetail } from '$lib/db/tables';
	import { type ItemView, DbView } from '$lib/db/views.js';
	import { supabase } from '$lib/supabase-client.js';

	export let data;

	let author: string;

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
	let createTransactionDetails: (CreateTransactionDetail | undefined)[] = [undefined];

	const addItem = () => {
		selectedItems.push(undefined);
		selectedItems = selectedItems;
		createTransactionDetails.push(undefined);
		createTransactionDetails = createTransactionDetails;
	};

	const removeItem = (index: number) => {
		selectedItems.splice(index, 1);
		selectedItems = selectedItems;
		createTransactionDetails.splice(index, 1);
		createTransactionDetails = createTransactionDetails;
	};
</script>

<!--
  TODO
  - Collapsible filter
  - Submit button
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
	<SearchBar bind:search={author} placeholder="Author" />
	{#each selectedItems as selectedItem, i}
		<TransactionDetail
			showRemoveButton={i > 0}
			onRemove={() => removeItem(i)}
			{itemViews}
			{selectedItem}
			bind:createTransactionDetail={createTransactionDetails[i]}
		/>
	{/each}
	<Button text="Add item" click={addItem} />
</div>
