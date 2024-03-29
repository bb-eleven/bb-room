<script lang="ts">
	import Title from '$lib/components/Title.svelte';
	import SearchButton from '$lib/components/buttons/SearchButton.svelte';
	import TextButton from '$lib/components/buttons/TextButton.svelte';
	import Input from '$lib/components/inputs/Input.svelte';
	import MultiSelect from '$lib/components/inputs/selects/MultiSelect.svelte';
	import { backIn, cubicOut } from 'svelte/easing';
	import { slide } from 'svelte/transition';
	import type { Category, ItemView, Location } from '$lib/database.types.short.js';
	import * as Mod from './mod.js';
	import { SelectionButtonType } from '$lib/components/buttons/selection-button-type.js';
	import CollapsibleItemView from './CollapsibleItemView.svelte';
	import { inou, ninou } from '$lib/utils.js';
	import { clickOutside } from '$lib/click-outside.js';
	import { defaultRotatingIconData, rotateIcon } from '$lib/components/icons/rotating-icon.js';
	import CollapseButton from '$lib/components/buttons/CollapseButton.svelte';
	import { IconSvg } from '$lib/components/icons/icon-svg.js';
	import type { Nullable } from 'vitest';
	import { goto } from '$app/navigation';
	import { browser } from '$app/environment';

	export let data;
	let itemViews: Mod.ItemViewMap = {};
	let itemViewIdSelecteds: { [id: number]: boolean } = {};
	let itemViewIdCollapseds: boolean[] = [];
	let selectedItemViews: Mod.ItemViewMap = {};
	let selectedItemViewsLength: number = 0;
	let selectedItemViewSelected: boolean = false;

	let searchName = '';
	let selectedCategories: Category['Row'][];
	let selectedLocations: Location['Row'][];
	let searchButtonRotatingIconData = defaultRotatingIconData();
	let collapseSelectedItemViewsTab = true;
	let collapseAllButtonText = 'collapse all';
	let collapseAll = false;

	Mod.getItemViews(data.supabase).then((data) => {
		itemViews = data ?? {};

		if (browser) {
			const selectedItemViewsStr = localStorage.getItem('selectedItemViews');
			if (ninou(selectedItemViewsStr)) {
				selectedItemViews = JSON.parse(selectedItemViewsStr);
			}
		}

		itemViewIdSelecteds = Object.fromEntries(
			Object.keys(itemViews).map((_id) => {
				const id = Number(_id);
				return [id, selectedItemViews.hasOwnProperty(id)];
			}),
		);
	});

	const toggleCollapse = () => {
		collapseAll = !collapseAll;
	};
	$: collapseAllButtonText = collapseAll ? 'expand all' : 'collapse all';

	const search = async () => {
		itemViews = await Mod.filterItemViews(
			data.supabase,
			searchName,
			selectedCategories,
			selectedLocations,
		);

		searchButtonRotatingIconData = rotateIcon(searchButtonRotatingIconData);
	};

	$: selectedItemViewsLength = Object.keys(selectedItemViews).length;

	const selectItemView = (id: Nullable<number>, selected: boolean) => {
		if (inou(id)) {
			return;
		}

		if (selectedItemViews.hasOwnProperty(id)) {
			delete selectedItemViews[id];
			itemViewIdSelecteds[id] = false;
		} else {
			selectedItemViews[id] = itemViews[id];
			itemViewIdSelecteds[id] = true;
		}

		selectedItemViews = selectedItemViews;
		itemViewIdSelecteds = itemViewIdSelecteds;
	};

	const deselectItemView = (id: Nullable<number>) => {
		if (inou(id) || !selectedItemViews.hasOwnProperty(id)) {
			return false;
		}

		delete selectedItemViews[id];
		itemViewIdSelecteds[id] = false;

		selectedItemViews = selectedItemViews;
		itemViewIdSelecteds = itemViewIdSelecteds;
		selectedItemViewSelected = false;
	};

	const openPage = (path: string) => {
		browser && localStorage.setItem('selectedItemViews', JSON.stringify(selectedItemViews));
		goto(path);
	};
</script>

<div class="relative flex items-end gap-2">
	<Title title="Inventory" />
	<SearchButton bind:rotatingIconData={searchButtonRotatingIconData} />

	<!-- Search inputs -->
	{#if searchButtonRotatingIconData.rotated}
		<div
			transition:slide={{ duration: 500, easing: cubicOut }}
			use:clickOutside={() => (searchButtonRotatingIconData.rotated = false)}
			class="absolute z-50 flex flex-col top-16 rounded-2xl w-full p-3 gap-4 bg-off-100 drop-shadow-2xl shadow-lg"
		>
			<Input label="Name" bind:value={searchName} />

			<MultiSelect
				label="Categories"
				bind:selected={selectedCategories}
				getInputText={Mod.getCategoriesInputDisplay}
				getOptionText={Mod.getCategoriesOptionDisplay}
				options={data.categories}
			/>

			<MultiSelect
				label="Locations"
				bind:selected={selectedLocations}
				getInputText={Mod.getLocationsInputDisplay}
				getOptionText={Mod.getLocationsOptionDisplay}
				options={data.locations}
			/>

			<div class="flex justify-end mt-4">
				<TextButton text="Search" click={search} />
			</div>
		</div>
	{/if}
</div>
<div class="mt-4 flex gap-4 items-end">
	<span class="block bg-brown-100 p-2 w-fit rounded-lg text-sm text-brown-500"
		>showing {Object.keys(itemViews).length} results
	</span>
	<TextButton
		text={collapseAllButtonText}
		click={toggleCollapse}
		class="rounded-lg px-2 py-1.5 h-fit"
	/>
</div>

<!-- Items -->
<div class="mt-4 h-[82%] overflow-y-scroll" style="display: {inou(itemViews) ? 'none' : 'block'}">
	{#each Object.values(itemViews) as itemView, i}
		<CollapsibleItemView
			bind:itemView={itemViews[itemView.id ?? -1]}
			selectionButtonType={SelectionButtonType.Check}
			bind:selected={itemViewIdSelecteds[itemView.id ?? -1]}
			collapsed={collapseAll}
			select={(s) => selectItemView(itemView.id, s)}
			class="mb-4 last:mb-20"
		/>
	{/each}
</div>

{#if selectedItemViewsLength > 0}
	<!-- TODO: refactor to its own component -->
	<div
		in:slide={{ duration: 200, easing: cubicOut }}
		out:slide={{ duration: 300, easing: cubicOut }}
		class="absolute left-0 bottom-0 rounded-t-2xl w-[calc(100%-1.5rem)] mx-3 p-3 gap-4 bg-off-100 drop-shadow-2xl shadow-[0px_10px_40px_rgba(0,0,0,0.1)]"
	>
		<div class="absolute right-6 -translate-y-3/4">
			<CollapseButton
				bind:collapsed={collapseSelectedItemViewsTab}
				icon={IconSvg.ChevronUp}
				class="bg-yellow-400 fill-yellow-600 animate-slide-up"
			/>
		</div>

		<div class="flex gap-2 items-center">
			<!-- <div class="px-3 py-2 bg-brown-100 text-brown-500 rounded-xl">
				{selectedItemViewIdOriginalIndexMap.size}
				{selectedItemViewIdOriginalIndexMap.size === 1 ? 'item' : 'items'} selected
			</div> -->
			<div class="px-3 py-2 bg-brown-100 text-brown-500 rounded-xl">
				{selectedItemViewsLength}
				{selectedItemViewsLength === 1 ? 'item' : 'items'} selected
			</div>

			<TextButton text="Move" click={() => openPage('/transactions/create')} />
			<TextButton text="Mass Move" click={() => openPage('/transactions/mass-move')} />
		</div>

		{#if !collapseSelectedItemViewsTab}
			<div
				in:slide={{ duration: 300, easing: backIn }}
				out:slide={{ duration: 400, easing: cubicOut }}
				class="max-h-[40vh] mt-4 overflow-y-scroll"
			>
				{#each Object.values(selectedItemViews) as selectedItemView}
					<!-- <div in:slide={{ duration: 300 }} out:slide={{ duration: 100 }}> -->
					<div>
						<CollapsibleItemView
							itemView={selectedItemView}
							selectionButtonType={SelectionButtonType.X}
							bind:selected={selectedItemViewSelected}
							collapsed={true}
							select={() => deselectItemView(selectedItemView?.id)}
							class="mb-4"
						/>
					</div>
				{/each}
			</div>
		{/if}
	</div>
{/if}
