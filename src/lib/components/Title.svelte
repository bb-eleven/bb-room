<script lang="ts">
	export let title: string;
</script>

<!-- min-width: 4 letters -->
<div class="rounded-full w-fit min-w-[4rem] px-6 py-2.5 bg-brown-600 text-off-200 {$$props.class}">
	<span class="text-lg">{title}</span>
</div>
