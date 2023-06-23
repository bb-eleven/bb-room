<script lang="ts">
	import Icon from '../icons/Icon.svelte';
	import type { IconSvg } from '../icons/icon-svg';
	import type { RotatingIconData } from './rotating-icon';

	export let icon: IconSvg;
	export let rotatingIconData: RotatingIconData;
</script>

<!-- TODO: figure out why animate-rotate-180 is used for rotated icon instead of upright icon... -->
<Icon
	{icon}
	class="{rotatingIconData.animate
		? rotatingIconData.rotated
			? 'animate-rotate-180'
			: 'animate-rotate-360'
		: ''} {$$props.class}"
/>
