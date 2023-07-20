<script lang="ts">
	import TextButton from "$lib/components/buttons/TextButton.svelte";

    let number = 0;
</script>

<h1>Number {number}</h1>
<TextButton text="+1" click={() => number++} />
<button on:click={() => number++}>+1</button>
<h1>Test Test Test</h1>
<h2>dog is xabier</h2>
<div id="dog">
    <h1>
        DOG DOG DOG DOG DOG DOG DOG DOG DOG
    </h1>
</div>

<style>
    #dog {
        color: black;
        background-color: aqua;
        position: absolute;
        width: 100vh;
        height: 100vh;
        font-size: 30rem;
    }
</style>