<script lang="ts">
	import { clickOutside } from '$lib/clickOutside';

	type CheckboxItem = any;

	export let label: string = 'a label';
	export let options: CheckboxItem[];
	export let getName: (item: CheckboxItem) => string | number;
	export let selected: CheckboxItem;

	let showOptions = false;

	const toggleOptions = () => {
		showOptions = !showOptions;
	};
</script>

<div class=" {$$props.class}">
	<div on:click={toggleOptions} class="flex justify-between">
		<span>{label}</span>
		<!-- TODO: use an actual logo -->
		<span>v</span>
	</div>
	{#if showOptions}
		<div
			class="absolute p-2 mr-2 space-y-2 bg-mirage min-w-fit h-fit max-h-[300px] overflow-y-scroll rounded drop-shadow-2xl shadow-lg shadow-mirage-darker-shadow/60"
			use:clickOutside={toggleOptions}
		>
			{#each options as item}
				<div
					on:click={() => {
						selected = item;
						showOptions = false;
					}}
					class="">{getName(item)}</div
				>
			{/each}
		</div>
	{/if}
</div>
