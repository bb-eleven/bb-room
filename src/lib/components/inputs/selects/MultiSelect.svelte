<script lang="ts">
	import { clickOutside } from '$lib/click-outside';
	import { slide } from 'svelte/transition';
	import RotatingIcon from '../../icons/RotatingIcon.svelte';
	import { IconSvg } from '../../icons/icon-svg';
	import { defaultRotatingIconData, rotateIcon } from '../../icons/rotating-icon';
	import { cubicOut } from 'svelte/easing';

	export let label: string;
	export let options: any[] = [];
	export let getOptionText: (selectedIndexes: any) => string;
	export let getInputText: (selectedIndexes: any[]) => {};
	export let selected: any[] = [];
	export let selectedIndexes = new Set<number>();

	$: options = options.map((option) => ({ ...option, selected: false }));
	$: selected = options.filter((_option, i) => selectedIndexes.has(i));

	let optionDisplay = getOptionText(selected);

	let rotatingIconData = defaultRotatingIconData();
	let showOptions: boolean;
	$: showOptions = rotatingIconData.rotated;
	$: optionDisplay = getOptionText(selected);

	const toggleOptions = () => {
		rotatingIconData = rotateIcon(rotatingIconData);
	};
	const selectOption = (i: number) => {
		selectedIndexes.has(i) ? selectedIndexes.delete(i) : selectedIndexes.add(i);
		selectedIndexes = selectedIndexes;
	};
</script>

<!-- Wrapper -->
<div class="w-full relative {$$props.class}">
	<div class="text-blue-600 text-sm mb-2">{label}</div>
	<!-- Selector -->
	<div
		class="rounded-full pl-4 pr-2 py-1 bg-blue-300 text-blue-600 fill-blue-600 select-none hover:cursor-pointer"
	>
		<div
			on:click={toggleOptions}
			on:keyup={toggleOptions}
			class="flex justify-between items-center"
		>
			<span class="text-ellipsis whitespace-nowrap overflow-hidden">{getInputText(selected)}</span>
			<RotatingIcon icon={IconSvg.ChevronDown} {rotatingIconData} class="h-8 shrink-0" />
		</div>
	</div>

	<!-- Options -->
	{#if showOptions}
		<div
			class="absolute z-50 min-w-fit w-full max-h-[50vh] rounded-2xl mt-2 bg-blue-300 overflow-y-scroll drop-shadow-2xl shadow-lg"
			transition:slide={{ duration: 500, easing: cubicOut }}
			use:clickOutside={toggleOptions}
		>
			{#each options as option, i}
				<div
					on:click={() => selectOption(i)}
					on:keyup={() => selectOption(i)}
					class="px-4 py-3 {selectedIndexes.has(i)
						? 'bg-blue-500 text-blue-200'
						: 'bg-blue-300 text-blue-600 hover:bg-blue-400 hover:text-blue-700'} hover:cursor-pointer"
				>
					{getOptionText(option)}
				</div>
				<hr class="last:h-0 border-none h-[1.5px] mx-0 bg-blue-500" />
			{/each}
		</div>
	{/if}
</div>