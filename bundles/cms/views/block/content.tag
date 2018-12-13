<block-content>
  <block on-refresh={ opts.onRefresh } on-save={ opts.onSave } on-remove={ opts.onRemove } block={ opts.block } data={ opts.data } on-update-title={ onUpdateTitle } on-complete-update-title={ onCompleteUpdateTitle } on-should-update-title={ onShouldUpdateTitle } on-update-content={ onUpdateContent } ref="block" class="block-wysiwyg">
    <yield to="body">
      <raw data={ { 'html' : opts.data.content } } />
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
