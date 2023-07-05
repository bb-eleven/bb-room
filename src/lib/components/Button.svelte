<script lang="ts">
	export let type: 'primary' | 'secondary' = 'primary';
	export let text: string = 'click';
	export let click = () => {};

	// TODO: create different types of buttons
</script>

<button on:click={click} class="{$$props.class} bg-comet text-mirage-darker py-1 px-4 rounded-full"
	>{text}</button
>
