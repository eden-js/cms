<block-content>
  <block ref="block" class="block-content" on-update-content={ onUpdateContent }>
    <yield to="body">
      <div if={ !opts.data.content } class="py-5 text-center">Add Content</div>
      <raw data={ { 'html' : opts.data.content } } />
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
      await opts.onSave(opts.block, opts.data);
    }

  </script>
</block-content>
