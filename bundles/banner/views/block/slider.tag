<block-slider>
  <block on-refresh={ opts.onRefresh } on-save={ opts.onSave } media={ this.media } preview={ opts.preview } language={ this.language } on-remove={ opts.onRemove } block={ opts.block } data={ opts.data } on-update-title={ onUpdateTitle } on-complete-update-title={ onCompleteUpdateTitle } on-should-update-title={ onShouldUpdateTitle } on-update-interval={ onUpdateInterval } on-update-category={ onUpdateCategory } on-update-show={ onUpdateShow } ref="block" class="block-slider">

    <yield to="modal">
      <div class="form-group">
        <label>Category</label>
        <input class="form-control" name="category" onchange={ opts.onUpdateCategory } value={ opts.data.category } />
      </div>
      <div class="form-group">
        <label>Interval</label>
        <input class="form-control" name="interval" onchange={ opts.onUpdateInterval } value={ opts.data.interval } />
      </div>
      <div class="form-group">
        <label>Show Buttons</label>
        <select class="form-control" onchange={ opts.onUpdateShow } name="buttons">
          <option value="true" selected={ (opts.data.show || {}).buttons }>Yes</option>
          <option value="false" selected={ !(opts.data.show || {}).buttons }>No</option>
        </select>
      </div>
      <div class="form-group">
        <label>Show Indicators</label>
        <select class="form-control" onchange={ opts.onUpdateShow } name="indicators">
          <option value="true" selected={ (opts.data.show || {}).indicators }>Yes</option>
          <option value="false" selected={ !(opts.data.show || {}).indicators }>No</option>
        </select>
      </div>
      <div class="form-group">
        <label>Show Background</label>
        <select class="form-control" onchange={ opts.onUpdateShow } name="background">
          <option value="true" selected={ (opts.data.show || {}).background }>Yes</option>
          <option value="false" selected={ !(opts.data.show || {}).background }>No</option>
        </select>
      </div>
      <div class="form-group">
        <label>Show Caption</label>
        <select class="form-control" onchange={ opts.onUpdateShow } name="caption">
          <option value="true" selected={ (opts.data.show || {}).caption }>Yes</option>
          <option value="false" selected={ !(opts.data.show || {}).caption }>No</option>
        </select>
      </div>
    </yield>

    <yield to="body">
      <div if={ !(opts.data.slides || []).length } class="py-5 text-center">
        Select slider Category
      </div>
      <div id="slider-{ opts.data.uuid }" class="carousel slide" ref="carousel">
        <ol class="carousel-indicators" if={ (opts.data.show || {}).indicators }>
          <li data-target="#slider-{ opts.data.uuid }" each={ indicator, i in opts.data.slides } data-slide-to={ i } class={ 'active' : i === 0 }></li>
        </ol>
        <div class="carousel-inner">
          <div each={ banner, i in opts.data.slides } class="{ 'carousel-item' : true, 'active' : i === 0 } { banner.id } { banner.class }" style={ (opts.data.show || {}).background ? 'background-image:url(' + opts.media.url(banner.image) + ');' : null }>
            <img src={ opts.media.url(banner.image) } alt={ banner.title[opts.language] } class="d-block w-100" if={ !(opts.data.show || {}).background }>
            <div class="carousel-caption" if={ (opts.data.show || {}).caption }>
              <h5 class="banner-title">{ banner.title[opts.language] }</h5>
              <div class="banner-content" if={ (banner.content[opts.language] || '').length }>
                <raw data={ { 'html' : banner.content[opts.language] } } />
              </div>
            </div>
          </div>
        </div>
        <a class="carousel-control-prev" href="#slider-{ opts.data.uuid }" role="button" data-slide="prev" if={ (opts.data.show || {}).buttons }>
          <span class="carousel-control-prev-icon" aria-hidden="true"></span>
          <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control-next" href="#slider-{ opts.data.uuid }" role="button" data-slide="next" if={ (opts.data.show || {}).buttons }>
          <span class="carousel-control-next-icon" aria-hidden="true"></span>
          <span class="sr-only">Next</span>
        </a>
      </div>
    </yield>

  </block>

  <script>
    // do mixins
    this.mixin('i18n');
    this.mixin('media');

    // set variables
    this.language  = this.i18n.lang();
    this.languages = this.eden.get('i18n').lngs || [];

    // check has language
    if (this.languages.indexOf(this.i18n.lang()) === -1) this.languages.unshift(this.i18n.lang());

    /**
     * on update name
     *
     * @param  {Event} e
     */
    onUpdateTitle (e) {
      // on enter
      let keycode = (event.keyCode ? event.keyCode : event.which);

      // check if enter
      if (parseInt(keycode) === 13) {
        // return on complete update
        return this.onCompleteUpdateTitle(e);
      }

      // set update
      opts.data.title = jQuery(e.target).val();
    }

    /**
     * on update name
     *
     * @param  {Event} e
     */
    async onCompleteUpdateTitle (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.refs.block.loading.title = true;
      this.refs.block.updating.title = false;

      // set name
      opts.data.title = jQuery('[ref="name"]', this.root).text();

      // update
      this.refs.block.update();

      // do update
      await opts.onSave(opts.block, opts.data);

      // set loading
      this.refs.block.loading.title = false;

      // update
      this.refs.block.update();
    }

    /**
     * on update category
     *
     * @param  {Event} e
     */
    async onUpdateCategory (e) {
      // set name
      opts.data.category = e.target.value;

      // do update
      await opts.onSave(opts.block, opts.data);
    }

    /**
     * on update category
     *
     * @param  {Event} e
     */
    async onUpdateInterval (e) {
      // set name
      opts.data.interval = parseInt(e.target.value);

      // do update
      await opts.onSave(opts.block, opts.data);
    }

    /**
     * on update category
     *
     * @param  {Event} e
     */
    async onUpdateShow (e) {
      // set name
      opts.data.show = opts.data.show || {};

      // set show name
      opts.data.show[jQuery(e.target).attr('name')] = jQuery(e.target).val() === 'true';

      // do update
      await opts.onSave(opts.block, opts.data);
    }

    /**
     * on update name
     *
     * @param  {Event} e
     */
    onShouldUpdateTitle (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.refs.block.updating.title = !this.refs.block.updating.title;

      // update
      this.refs.block.update();

      // set inner test
      jQuery('[ref="name"]', this.root).focus();
    }

    /**
     * on language update function
     */
    this.on('update', () => {
      // set language
      this.language = this.i18n.lang();

    });

    /**
     * on mount function
     */
    this.on('mount', () => {
      // return if not frontend
      if (!this.eden.frontend) return;

      // set interval
      jQuery(this.refs.carousel).carousel({
        'interval' : opts.data.interval || 2000
      });
    });

  </script>
</block-slider>
