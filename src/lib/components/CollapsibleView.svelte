<script lang="ts">
	import CollapseButton from './buttons/CollapseButton.svelte';
	import SelectionButton from './buttons/SelectionButton.svelte';
	import type { SelectionButtonType } from './buttons/selection-button-type';
	import type { Nullable } from 'vitest';

	export let collapsed = true;
	export let selectionButtonType: Nullable<SelectionButtonType> = null;
	export let selected: boolean = false;
	export let select: (selected: boolean) => void = () => {};
</script>

<div class="bg-off-200 rounded-2xl {$$props.class}">
	<!-- Header -->
	<div
		class="px-4 py-3 bg-off-300 {$$slots.body || !collapsed
			? 'rounded-t-2xl'
			: 'rounded-2xl'} flex justify-between"
	>
		<div class="text-ellipsis whitespace-nowrap overflow-hidden">
			<slot name="title" />
		</div>
		<div class="relative min-w-[6rem]">
			<!-- Button container -->
			<div class="absolute right-0 translate-y-1 flex flex-row gap-2">
				<CollapseButton bind:collapsed />
				<SelectionButton
					type={selectionButtonType}
					bind:clicked={selected}
					click={() => {
						select(selected);
					}}
				/>
			</div>
		</div>
	</div>

	<slot name="body" />

	<!-- Body -->
	{#if !collapsed}
		<slot name="collapsible-body" />
	{/if}
</div>
