<script lang="ts">
	export let text: string;
	export let click = () => {};
</script>

<button
	on:click={click}
	class="h-10 py-1 px-4 rounded-full bg-blue-600 text-off-200 {$$props.class}"
>
	{text}
</button>
