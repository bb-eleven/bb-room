<script lang="ts">
	import RotatingIcon from '../icons/RotatingIcon.svelte';
	import { IconSvg } from '../icons/icon-svg';
	import {
		defaultRotatingIconData,
		rotateIcon,
		type RotatingIconData,
	} from '../icons/rotating-icon';

	// Collapsed by default
	export let icon: IconSvg.ChevronUp | IconSvg.ChevronDown = IconSvg.ChevronDown;
	export let click = () => {
		collapsed = !collapsed;
	};

	export let collapsed = true;
	let rotatingIconData: RotatingIconData = defaultRotatingIconData();
	$: rotatingIconData = rotateIcon({ ...rotatingIconData, rotated: collapsed });
</script>

<button on:click={click} class="w-10 p-1 rounded-full bg-brown-300 fill-brown-100 {$$props.class}">
	<RotatingIcon {icon} {rotatingIconData} />
</button>
