<script lang="ts">
	import type { Nullable } from 'vitest';
	import InputError from './InputError.svelte';

	export let label: string;
	export let value: Nullable<string> = '';
	export let placeholder = 'type...';
	export let onBlur = () => {};
	export let error: Nullable<string> = null;
</script>

<div class={$$props.class}>
	<div class="text-blue-600 text-sm mb-2">{label}</div>
	<div>
		<input
			{placeholder}
			spellcheck="false"
			bind:value
			on:blur={onBlur}
			class="px-4 py-1.5 w-full bg-blue-200 placeholder:text-blue-400 text-blue-600 select-none rounded-xl border-2 border-blue-400 active:outline-none focus:outline-none"
		/>
	</div>
	<InputError {error} />
</div>
