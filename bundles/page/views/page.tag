<page-page>
  <div class="cms-placement-blocks" data-placement={ (opts.item || {}).id || 'page' } data-is="eden-blocks" placement={ this.page.get('placement') || {} } for="frontend" blocks={ opts.blocks } on-save={ onPlacement } position={ (opts.item || {}).id || 'page' } />

  <script>
    // do mixins
    this.mixin('i18n');
    this.mixin('model');

    // set update
    this.type    = opts.type;
    this.page    = this.model('page', opts.item);
    this.loading = {};

    // load data
    this.language = this.i18n.lang();

    /**
     * set placement
     *
     * @param  {Placement} placement
     */
    async onPlacement (placement) {
      // check id
      if (placement.get('id') !== (this.page.get('placement') || {}).id) {
        // update placement
        this.page.set('placement', placement.get());

        // save
        await this.savePage(this.page);
      }
    }

    /**
     * saves page
     *
     * @param  {Object}  page
     *
     * @return {Promise}
     */
    async savePage (page) {
      // set loading
      this.loading.save = true;

      // update view
      this.update();

      // check type
      if (!page.type) page.set('type', opts.type);

      // set input values
      jQuery('[data-input]', this.refs.form).each((i, elem) => {
        // set value
        page.set(jQuery(elem).attr('data-input'), jQuery(elem).val());
      });

      // log data
      let res = await fetch('/admin/page/' + (page.get('id') ? page.get('id') + '/update' : 'create'), {
        'body'    : JSON.stringify(this.page.get()),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let data = await res.json();

      // set logic
      for (let key in data.result) {
        // clone to page
        page.set(key, data.result[key]);
      }

      // set loading
      this.loading.save = false;

      // update view
      this.update();
    }

    /**
     * on language update function
     */
    this.on('update', () => {
      // set language
      this.language = this.i18n.lang();
      
    });

    /**
     * on mount
     *
     * @type {mount}
     */
    this.on('mount', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // set page
      this.page = this.model('page', opts.item);
      
      // set to placements
      if (this.page.id) this.eden.set('placements.' + this.page.id, this.page.get('placement'));

    });

  </script>
</page-page>
