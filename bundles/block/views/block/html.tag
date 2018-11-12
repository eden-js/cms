<block-html>
  <div data-placement={ this.block.placement } id={ this.block.id }>
    <raw data={ { 'html' : (this.block.content || {})[this.language] } } />
  </div>

  <script>
    // do mixins
    this.mixin('i18n');
    this.mixin('block');

    // set block
    this.language = this.i18n.lang();

    /**
     * on language update function
     */
    this.on('update', () => {
      // set language
      this.language = this.i18n.lang();
    });

  </script>
</block-html>
