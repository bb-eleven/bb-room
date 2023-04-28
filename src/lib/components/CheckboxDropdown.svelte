<script lang="ts">
	import { clickOutside } from '$lib/clickOutside';
	import Checkbox from './Checkbox.svelte';

	type CheckboxItem = any;

	export let label: string = 'a label';
	export let options: CheckboxItem[];
	export let getName: (item: CheckboxItem) => string | number;
	export let selected = [];

	let showOptions = false;

	options = options.map((item) => ({
		...item,
		_checked: false,
	}));

	$: selected = options
		.filter((item) => item._checked)
		.map((item) => {
			const { _checked, ...originalItem } = item;
			return originalItem;
		});

  const toggleOptions = () => {
    showOptions = !showOptions;
  }
</script>

<div class=" {$$props.class}">
  <div on:click={toggleOptions} class="flex justify-between">
    <span>{label}</span>
    <!-- TODO: use an actual logo -->
    <span>v</span>
  </div>
  {#if showOptions}
    <div class="absolute p-2 mr-2 space-y-2 bg-mirage min-w-fit h-fit max-h-[300px] overflow-y-scroll rounded drop-shadow-xl"
      use:clickOutside={toggleOptions}
    >
      {#each options as item, i}
        <div class="flex items-center">
          <Checkbox bind:checked={options[i]._checked} on:click={() => console.log(options)} />
          <span>{getName(item)}</span>
        </div>
      {/each}
    </div>
  {/if}
</div>
