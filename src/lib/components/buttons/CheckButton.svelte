<script lang="ts">
	import Icon from '../icon/Icon.svelte';
	import { IconSvg } from '../icon/icon-svg';

	export let clicked = false;
	export let click = () => {};
</script>

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
