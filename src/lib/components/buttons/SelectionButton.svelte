<script lang="ts">
	import { ninou } from '$lib/utils';
	import type { Nullable } from 'vitest';
	import Icon from '../icons/Icon.svelte';
	import { IconSvg } from '../icons/icon-svg';
	import { SelectionButtonType } from './selection-button-type';

	export let clicked = false;
	export let type: Nullable<SelectionButtonType>;
	export let click = () => {};
</script>

<!-- TODO: possible refactor to avoid duplicating code -->
{#if type === SelectionButtonType.Check}
	<button
		on:click={() => {
			clicked = !clicked;
			click();
		}}
		class="w-10 p-2 rounded-full {clicked
			? 'bg-off-600 fill-green-200'
			: 'bg-off-500 fill-off-100 hover:fill-green-100'} {$$props.class}"
	>
		<Icon icon={IconSvg.Check} class="" />
	</button>
{:else if type === SelectionButtonType.X}
	<!-- {clicked
		 	? 'bg-off-600 fill-red-200'
		 	: 'bg-off-500 fill-off-100 hover:fill-red-100'} -->
	<button
		on:click={() => {
			clicked = !clicked;
			click();
		}}
		class="w-10 p-2 rounded-full bg-off-500 fill-off-100 {$$props.class}"
	>
		<Icon icon={IconSvg.X} class="" />
	</button>
{/if}
