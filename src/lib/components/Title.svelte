<script lang="ts">
	export let title: string;
	console.log(title);
</script>

<!-- min-width: 4 letters -->
<div class="rounded-full w-fit min-w-[4rem] px-5 py-2 bg-brown-600 text-off-200 {$$props.class}">
	<span>{title}</span>
</div>
