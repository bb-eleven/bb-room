<script lang="ts">
	import { ninou } from '$lib/utils';
	import type { Nullable } from 'vitest';
	import IconButton from '../buttons/IconButton.svelte';
	import { IconSvg } from '../icons/icon-svg';
	import InputError from './InputError.svelte';

	export let label: string;
	export let value: number;
	export let placeholder = 'type...';

	export let min = 0;
	export let max = 9999;

	// Set value to either min/max if out of range
	$: if (ninou(value)) {
		if (value < min) {
			value = min;
		} else if (value > max) {
			value = max;
		}
	}

	export let onBlur = () => {};
	export let error: Nullable<string> = null;
</script>

<div class={$$props.class}>
	<div class="text-blue-600 text-sm mb-2">{label}</div>
	<div class="w-full flex items-center gap-2">
		<input
			disabled={ninou(value) && (value <= min || value >= max)}
			type="number"
			{placeholder}
			bind:value
			on:blur={onBlur}
			class="w-full grow px-4 py-1.5 bg-blue-200 placeholder:text-blue-400 text-blue-600 disabled:text-blue-400 select-none rounded-xl border-2 border-blue-400 disabled:border-blue-200 active:outline-none focus:outline-none"
		/>
		<IconButton
			disabled={value <= min}
			class="shrink-0 w-9 p-1 bg-blue-300 fill-blue-500 disabled:bg-blue-200 disabled:fill-blue-300"
			icon={IconSvg.Minus}
			click={() => --value}
		/>
		<IconButton
			disabled={value >= max}
			class="shrink-0 w-9 p-1 bg-blue-300 fill-blue-500 disabled:bg-blue-200 disabled:fill-blue-300"
			icon={IconSvg.Plus}
			click={() => ++value}
		/>
	</div>
	<InputError {error} />
</div>

<style>
	input[type='number']::-webkit-inner-spin-button,
	input[type='number']::-webkit-outer-spin-button {
		-webkit-appearance: none;
	}

	input[type='number'] {
		appearance: textfield;
		-moz-appearance: textfield;
	}
</style>
