<page-page>
  <div class="container">
    <div class="card my-5">
      <div class="card-header">
        { (opts.item.title || {})[this.language] }
      </div>
      <div class="card-body">
        <raw html={ (opts.item.content || {})[this.language] } />
      </div>
    </div>
  </div>

  <script>
    // do mixins
    this.mixin ('i18n');

    // set content
    this.language = this.i18n.lang();

    /**
     * on language update function
     */
    this.on ('update', () => {
      // set language
      this.language = this.i18n.lang();
    });

  </script>
</page-page>
