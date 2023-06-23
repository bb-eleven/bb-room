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
	class="py-2 px-3 rounded-full bg-blue-600 fill-blue-200 flex items-center gap-1 {$$props.class}"
>
	<Icon icon={IconSvg.Search} class="w-7" />
	<RotatingIcon {icon} {rotatingIconData} class="w-6" />
</button>
