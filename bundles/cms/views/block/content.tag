<block-content>
  <block ref="block" class="block-content" on-update-content={ onUpdateContent } get-content={ getContent }>
    <yield to="body">
      <div if={ opts.preview }>
        <div if={ !opts.data.content } class="py-5 text-center">Add Content</div>
        <raw data={ { 'html' : opts.getContent() } } />
      </div>
      <div if={ !opts.preview }>
        <editor content={ opts.data.content } on-update={ opts.onUpdateContent } air-mode={ true } />
      </div>
    </yield>

    <yield to="modal">
      <div class="form-group">
        <label>
          Content
        </label>
        <editor content={ opts.data.content } on-update={ opts.onUpdateContent } />
      </div>
    </yield>
  </block>

  <script>
  
    /**
     * on update name
     *
     * @param  {Event} e
     */
    async onUpdateContent (content) {
      // set name
      opts.data.content = content;

      // do update
      await opts.onSave(opts.block, opts.data, opts.placement, true);
    }

    /**
     * get content
     *
     * @return {*}
     */
    getContent () {
      // @todo allow bad dom throw

      // return content
      return opts.data.content;
    }

  </script>
</block-content>
