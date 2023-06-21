<script lang="ts">
	import Icon from '../icon/Icon.svelte';
	import { IconSvg } from '../icon/icon-svg';

	export let click = () => {};

	let rotate = 'none'; // ensures icon isn't animated when first loaded
	let icon: IconSvg.ChevronUp | IconSvg.ChevronDown = IconSvg.ChevronDown;
</script>

<button
	on:click={() => {
		rotate = rotate === '180' ? '360' : '180';
		click();
	}}
	class="{$$props.class} rounded-full"
>
	<Icon {icon} class="animate-rotate-{rotate}" />
</button>
