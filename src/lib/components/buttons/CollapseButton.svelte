<script lang="ts">
	import Icon from '../icon/Icon.svelte';
	import { IconSvg } from '../icon/icon-svg';

	// Collapsed by default
	export let icon: IconSvg.ChevronUp | IconSvg.ChevronDown = IconSvg.ChevronDown;
	export let click = () => {};

	let rotate = 'none'; // Ensures icon isn't animated when first loaded
</script>

<button
	on:click={() => {
		rotate = rotate === '180' ? '360' : '180';
		click();
	}}
	class="w-10 p-1 rounded-full bg-brown-300 fill-brown-100 {$$props.class}"
>
	<!-- For Tailwind compiler to pick up animate-rotate-[180|360] -->
	<!-- class="animate-rotate-180 animate-rotate-360" -->
	<Icon {icon} class="animate-rotate-{rotate}" />
</button>
