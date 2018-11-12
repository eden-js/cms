<block-html-quick>
  <div data-placement={ this.block.placement } class="block-edit-quick">
    <editor content={ (block().content || {})[lng] } each={ lng, i in this.languages } hide={ this.language !== lng } data-lang="content-{ lng }" name="content[{ lng }]" on-change={ onUpdate } />
  </div>

  <script>
    // do mixins
    this.mixin('i18n');
    this.mixin('block');

    // set block
    this.language  = this.i18n.lang();
    this.languages = this.eden.get ('i18n').lngs || [];

    // check has language
    if (this.languages.indexOf(this.i18n.lang()) === -1) this.languages.unshift(this.i18n.lang());

    /**
     * get category
     *
     * @return {Object}
     */
    block () {
      // return category
      return opts.block;
    }

    /**
     * updates block
     *
     * @param  {Event} e
     */
    onUpdate (e) {
      // set data
      let content = {};

      // loop languages
      for (let language of this.languages) {
        // set content
        content[language] = jQuery('textarea', jQuery('[data-lang="content-' + language + '"]', this.refs.content)).val();
      }

      // run update
      opts.onUpdate(opts.block, 'content', content);
    }

    /**
     * on language update function
     */
    this.on('update', () => {
      // set language
      this.language = this.i18n.lang();
    });

  </script>
</block-html-quick>
