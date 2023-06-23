<script lang="ts">
	import RotatingIcon from '../icon/RotatingIcon.svelte';
	import { IconSvg } from '../icon/icon-svg';
	import { defaultRotatingIconData, rotateIcon } from '../icon/rotating-icon';

	// Collapsed by default
	export let icon: IconSvg.ChevronUp | IconSvg.ChevronDown = IconSvg.ChevronDown;
	export let click = () => {};

	export let rotatingIconData = defaultRotatingIconData();
</script>

<button
	on:click={() => {
		rotatingIconData = rotateIcon(rotatingIconData);
		click();
	}}
	class="w-10 p-1 rounded-full bg-brown-300 fill-brown-100 {$$props.class}"
>
	<RotatingIcon {icon} {rotatingIconData} />
</button>
