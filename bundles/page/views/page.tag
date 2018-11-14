<page-page>
  <editor-view placement={ opts.item.placement } />

  <script>
    // do mixins
    this.mixin('i18n');

    // set content
    this.language = this.i18n.lang();

    /**
     * on language update function
     */
    this.on('update', () => {
      // set language
      this.language = this.i18n.lang();
      
    });

  </script>
</page-page>
