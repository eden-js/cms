<block-view-slider>
  <div id="slider-{ opts.data.uuid }" class="carousel slide" data-ride="carousel">
    <ol class="carousel-indicators" if={ (opts.data.show || {}).indicators }>
      <li data-target="#slider-{ opts.data.uuid }" each={ indicator, i in opts.data.slides } data-slide-to={ i } class={ 'active' : i === 0 }></li>
    </ol>
    <div class="carousel-inner">
      <div each={ banner, i in opts.data.slides } class={ 'carousel-item' : true, 'active' : i === 0 } style={ (opts.data.show || {}).background ? 'background-image:url(' + this.media.url(banner.image) + ');' : null }>
        <img src={ this.media.url(banner.image) } alt={ banner.title[this.language] } class="d-block w-100" if={ !(opts.data.show || {}).background }>
        <div class="carousel-caption d-none d-md-block" if={ (opts.data.show || {}).caption }>
          <h5 class="banner-title">{ banner.title[this.language] }</h5>
          <div class="banner-content" if={ banner.content[this.language].length }>
            <raw data={ { 'html' : banner.content[this.language] } } />
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
     * on language update function
     */
    this.on('update', () => {
      // set language
      this.language = this.i18n.lang();

    });
  </script>
</block-view-slider>
