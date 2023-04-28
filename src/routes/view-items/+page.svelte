<script lang="ts">
	import Button from '$lib/components/Button.svelte';
	import CheckboxDropdown from '$lib/components/CheckboxDropdown.svelte';
	import SearchBar from '$lib/components/SearchBar.svelte';
	import { DbFunction } from '$lib/db/functions.js';
	import type { Category, Location } from '$lib/db/tables.js';
	import { DbView, type ItemView } from '$lib/db/views';
	import { supabase } from '$lib/supabase-client';
	import { inou } from '$lib/utils';

	export let data;

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

	const click = async () => {
		const { data, error } = await supabase
			.rpc(DbFunction.FilterItemView, {
				_name_query: `%${itemName ?? ''}%`,
				_category_names: selectedCategories.map(({ name }) => name),
				_location_codes: selectedLocations.map(({ code }) => code)
			})
			.select();
		itemViews = data as ItemView[];
	};

	const sumLocationQuantities = (locationQuantities?: number[]) => {
		return inou(locationQuantities) ? '-' : '' + locationQuantities?.reduce((a, b) => a + b, 0);
	};
</script>

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
		<Button text="Search" {click} />
	</div>
</div>

<!-- div is used instead of table because border-collapse and border-radius don't work together -->
<div class="mt-4 h-fit rounded-md border-2 border-comet bg-comet">
	<div class="bg-mirage text-left rounded">
		<div class="thead grid grid-cols-5 grid-flow-row break-all">
			<div
				class="select-none hover:cursor-pointer hover:bg-comet focus:bg-comet active:bg-comet hover:text-mirage focus:text-mirage th col-span-1 p-1 border-r-2 border-comet"
			>
				Name
			</div>
			<div
				class="select-none hover:cursor-pointer hover:bg-comet focus:bg-comet active:bg-comet hover:text-mirage focus:text-mirage th col-span-1 p-1 border-r-2 border-comet"
			>
				Variant
			</div>
			<div
				class="select-none hover:cursor-pointer hover:bg-comet focus:bg-comet active:bg-comet hover:text-mirage focus:text-mirage th col-span-1 p-1 border-r-2 border-comet"
			>
				Category
			</div>
			<div
				class="select-none hover:cursor-pointer hover:bg-comet focus:bg-comet active:bg-comet hover:text-mirage focus:text-mirage th col-span-1 p-1 border-r-2 border-comet"
			>
				Locations
			</div>
			<div
				class="select-none hover:cursor-pointer hover:bg-comet focus:bg-comet active:bg-comet hover:text-mirage focus:text-mirage th col-span-1 p-1 border-comet"
			>
				Total Quantity
			</div>
		</div>
		<div class="tbody break-all whitespace-pre-wrap">
			{#each itemViews as { name, variant_name, category_names, location_codes, location_quantities }}
				<div class="tr grid grid-cols-5 grid-flow-row border-t-2 border-comet">
					<div class="td p-1 border-r-2 border-comet">{name}</div>
					<div class="td p-1 border-r-2 border-comet">{variant_name ?? '-'}</div>
					<div class="td p-1 border-r-2 border-comet">{category_names?.join(',\n') ?? '-'}</div>
					<div class="td p-1 border-r-2 border-comet">{location_codes?.join(',\n') ?? '-'}</div>
					<div class="td p-1 border-comet">{sumLocationQuantities(location_quantities)}</div>
				</div>
			{/each}
		</div>
	</div>
</div>
