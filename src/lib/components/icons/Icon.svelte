<script lang="ts">
	import type { IconSvg } from './icon-svg';

	export let icon: IconSvg;
</script>

<svg class={$$props.class} viewBox="0 0 24 24">{@html icon}</svg>
