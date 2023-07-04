<script lang="ts">
	import { ninou } from '$lib/utils';
	import type { Nullable } from 'vitest';

	export let error: Nullable<string>;
</script>

{#if ninou(error)}
	<div class="w-full mt-2 py-1 px-3 rounded-lg bg-red-400 text-red-100 {$$props.class}">
		<span>{error}</span>
	</div>
{/if}
