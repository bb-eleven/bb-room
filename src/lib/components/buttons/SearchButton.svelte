<script lang="ts">
	import Icon from '../icons/Icon.svelte';
	import RotatingIcon from '../icons/RotatingIcon.svelte';
	import { IconSvg } from '../icons/icon-svg';
	import { defaultRotatingIconData, rotateIcon } from '../icons/rotating-icon';

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
	class="h-10 py-1 px-2 rounded-full bg-blue-600 fill-blue-200 flex items-center {$$props.class}"
>
	<Icon icon={IconSvg.Search} class="h-5/6" />
	<RotatingIcon {icon} {rotatingIconData} class="ml-1 h-2/3" />
</button>
