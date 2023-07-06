<script lang="ts">
	import Icon from '../icons/Icon.svelte';
	import type { IconSvg } from '../icons/icon-svg';

	export let click = () => {};
	export let icon: IconSvg;
	export let disabled = false;
</script>

<button
	{disabled}
	on:click={click}
	class="{$$props.class} rounded-full animate-flip focus:rotate-180"><Icon {icon} /></button
>
