// Dispatch event on click outside of node
// https://github.com/sveltejs/svelte/issues/3012
export const clickOutside = (element: HTMLElement, callback: Function, include?: string) => {

  const handleClick = (event: Event) => {
    const target = event.target as HTMLElement;
    if (element && !element.contains(target) && !event.defaultPrevented) {
      event.stopPropagation();
      callback();
    }
  }

  document.addEventListener('click', handleClick, true);

  return {
    destroy() {
      document.removeEventListener('click', handleClick, true);
    }
  }
}
