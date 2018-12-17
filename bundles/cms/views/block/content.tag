<block-content>
  <block on-refresh={ opts.onRefresh } on-save={ opts.onSave } on-remove={ opts.onRemove } block={ opts.block } data={ opts.data } preview={ opts.preview } on-update-content={ onUpdateContent } ref="block" class="block-content">
    <yield to="body">
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
      console.log('data');
      // set name
      opts.data.content = content;

      // do update
      await opts.onSave(opts.block, opts.data);
    }

  </script>
</block-content>
