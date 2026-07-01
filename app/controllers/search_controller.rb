class SearchController < ApplicationController
  def index
    q = params[:q].to_s.strip
    return render json: { temple: [], forum: [], market: [] } if q.blank? || q.length < 2

    like = "%#{q}%"

    temple = MarketTempleItem.active
                             .where("title ILIKE ? OR body ILIKE ?", like, like)
                             .limit(5)
                             .map { |i| serialize_temple(i) }

    forum  = []
    forum += CivicBill.where("title ILIKE ? OR identifier ILIKE ?", like, like)
                      .limit(4).map { |b| serialize_bill(b) }
    forum += CivicRepresentative.where("name ILIKE ? OR office ILIKE ?", like, like)
                                .limit(3).map { |r| serialize_rep(r) }

    market = MarketProvider.active
                           .joins(:market_subcategory)
                           .where("market_providers.name ILIKE ? OR market_providers.description ILIKE ?", like, like)
                           .limit(6)
                           .map { |p| serialize_provider(p) }

    render json: { temple: temple, forum: forum, market: market }
  end

  private

  def serialize_temple(i)
    { id: i.id, pillar: 't', type: i.item_type, icon: 'ti-book',
      title: i.title, subtitle: i.body.to_s.truncate(100),
      meta: "Temple · #{i.market_subcategory&.name || i.market_domain&.name}" }
  end

  def serialize_bill(b)
    { id: b.id, pillar: 'f', type: 'bill', icon: 'ti-file-description',
      title: [b.identifier, b.title.presence&.truncate(60)].compact.join(' — '),
      subtitle: b.plain_summary.to_s.truncate(100),
      meta: "Forum · #{b.jurisdiction} · #{b.status}" }
  end

  def serialize_rep(r)
    { id: r.id, pillar: 'f', type: 'official', icon: 'ti-user',
      title: r.name,
      subtitle: r.office.to_s,
      meta: "Forum · #{r.jurisdiction}" }
  end

  def serialize_provider(p)
    { id: p.id, pillar: 'm', type: p.provider_type, icon: 'ti-building-store',
      title: p.name,
      subtitle: p.description.to_s.truncate(100),
      meta: "Market · #{p.market_subcategory.name} · #{p.neighborhood.presence || p.city}" }
  end
end
